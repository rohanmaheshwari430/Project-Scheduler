from db import db
from db import Project, Task, User
from flask import Flask, request, json
import datetime

app = Flask(__name__)
db_filename = "project_scheduler.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps({'success': True, 'data': data}), code

def failure_response(error, code=404):
    return json.dumps({'success': False, 'error': error}), code

#routes
@app.route('/api/projects/')
def get_projects():
    data = []
    for p in Project.query.all():
        formatted_p = p.serialize()
        data.append(formatted_p)
    return success_response(data)

@app.route('/api/projects/', methods=["POST"])
def create_project():
    body = json.loads(request.data)
    if(body.get('title') == None or body.get('description') == None):
        return failure_response('One or more fields is missing.')
    else:
        new_project = Project(title = body.get('title'), description = body.get('description'))
        db.session.add(new_project)
        db.session.commit()
        formatted_project = new_project.serialize()
        formatted_project['tasks'] = [t.serialize() for t in Task.query.filter_by(project_id = formatted_project.get('id')).all()]
        formatted_project['users'] = [u.serialize() for u in new_project.users]
        return success_response(formatted_project, 201)

@app.route("/api/projects/<int:project_id>/", methods=["PATCH"])
def update_project(project_id):
    body = json.loads(request.data)
    selected_project = Project.query.filter_by(id = project_id).first()
    if selected_project == None:
        return failure_response("Project not found.")
    if not isinstance(body.get('title'), str) and not isinstance(body.get('description'), str) == None and not all(isinstance(elem, User) for elem in body.get('users')):
        return failure_response("Please enter a valid entry for at least one of the fields.")
    if isinstance(body.get('title'), str):
        selected_project.title = body.get('title')
    if isinstance(body.get('description'), str):
        selected_project.description = body.get('description')
    if not body.get('users') == None and all(isinstance(elem, User) for elem in body.get('users')):
        selected_project.title = body.get('title')

    #update tasks
    db.session.commit()
    return success_response(selected_project.serialize(), 200)

@app.route('/api/projects/<int:project_id>/', methods=["DELETE"])
def delete_project(project_id):
    selected_project = Project.query.filter_by(id = project_id).first() 
    if selected_project == None:
        return failure_response("Project not found.")
    db.session.delete(selected_project)
    db.session.commit()
    return success_response(selected_project.serialize(), 200)


#tasks api endpoiint
# projects -> task 
@app.route('/api/projects/<int:project_id>/', methods=["POST"]) 
def create_task(project_id):
    selected_project = Project.query.filter_by(id = project_id).first()
    if selected_project == None: 
        return failure_response("Project not found.")
    body = json.loads(request.data)
    if body.get('title') == None or body.get('deadline') == None or body.get('body') == None:
        return failure_response("One or more fields are missing.")
    else:
        new_task = Task(title = body.get('title'), deadline= body.get('deadline'), description = body.get('body'), project_id = project_id)
    db.session.add(new_task)
    db.session.commit()

    return success_response("Task created!")


#add user to task
@app.route('/api/projects/tasks/<int:task_id>/', methods=["POST"])
def add_user_to_task(task_id):

    #query users by email 
    #if email not exist, create user like below
    
    #check if name matches if email matches, throw error if diffenrent (given email exists)
    selected_task = Task.query.filter_by(id = task_id).first()
    if selected_task == None:
        return failure_response("Task not found.")
    body = json.loads(request.data)
    if body.get('name') == None:
        return failure_response("One or more fields is missing.")
    new_user = User(name = body.get('name'), email = body.get('email', None))
    db.session.add(new_user)
    db.commit()
    selected_task.users.append(new_user)
    db.commit()
    

#add user to project


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)