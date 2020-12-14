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
    db.drop_all()
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
        formatted_p['tasks'] = [t.serialize() for t in Task.query.filter_by(project_id = formatted_p.get('id')).all()]
        formatted_p['users'] = [u.serialize() for u in p.users]
        data.append(formatted_p)
    return success_response(data, 200)

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
    if not isinstance(body.get('title'), str) and not isinstance(body.get('description'), str) == None:
        return failure_response("Please enter a valid entry for at least one of the fields.")
    if isinstance(body.get('title'), str):
        selected_project.title = body.get('title')
    if isinstance(body.get('description'), str):
        selected_project.description = body.get('description')
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

@app.route('/api/tasks/<int:project_id>/', methods=["POST"])
def create_task(project_id):
    body = json.loads(request.data)
    if (body.get('title') == None or body.get('deadline') == None):
        return failure_response('One or more fields is missing.')
    else:
        selected_project = Project.query.filter_by(id = project_id).first()
        if selected_project == None:
            return failure_response("Project not found.")
        new_task = Task(title = body.get('title'), description = body.get('body'), deadline = body.get('deadline'), project_id = project_id)
        db.session.add(new_task)
        db.session.commit()
        formatted_task = new_task.serialize()
        formatted_task['project'] = selected_project.serialize()
        return success_response(formatted_task, 201)

@app.route('/api/projects/<int:project_id>/tasks/')
def get_tasks_for_project(project_id):
    data = []
    for t in Task.query.filter_by(project_id = project_id).all():
        formatted_task = t.serialize()
        data.append(formatted_task)
        
    return success_response(data)

#add user to task
@app.route('/api/tasks/<int:task_id>/users/', methods=["POST"])
def add_user_to_task(task_id):
    body = json.loads(request.data)
    #query users by email 
    selected_user = User.query.filter_by(email = body.get('email')).first()
    selected_task = Task.query.filter_by(id = task_id).first()
    selected_project = Project.query.filter_by(id = selected_task.project_id).first()
    if selected_task == None:
        return failure_response("Task not found.")
    if selected_user == None: #if email not exist, create user like below
        new_user = User(name = body.get('name'), email = body.get('email', None))
        db.session.add(new_user)
        selected_task.users.append(new_user)
        selected_project.users.append(new_user)
        db.session.commit()
        selected_user = new_user
    else:
        if body.get('name') != selected_user.name:
            return failure_response("Invalid user. Two users cannot have the same email.")
        selected_task.users.append(selected_user)
        db.session.commit()

    formatted_selected_user = selected_user.serialize()
    return success_response("User has been added to: " + selected_task.serialize()["title"], 201)

@app.route("/api/tasks/<int:task_id>/", methods=["PATCH"])
def update_task(task_id):
    body = json.loads(request.data)
    selected_task = Task.query.filter_by(id = task_id).first()
    if selected_task == None:
        return failure_response("Task not found.")
    if not isinstance(body.get('title'), str) and not isinstance(body.get('body'), str) and not isinstance(body.get('deadline'), str) == None:
        return failure_response("Please enter a valid entry for at least one of the fields.")
    if isinstance(body.get('title'), str):
        selected_task.title = body.get('title')
    if isinstance(body.get('body'), str):
        selected_task.body = body.get('body')
    if isinstance(body.get('deadline'), str):
        selected_task.deadline = body.get('deadline')
    db.session.commit()
    return success_response(selected_project.serialize(), 200)

@app.route('/api/tasks/<int:task_id>/', methods=["DELETE"])
def delete_task(task_id):
    selected_task = Task.query.filter_by(id = task_id).first()
    if selected_task == None:
        return failure_response("Task not found.")
    db.session.delete(task_id)
    db.session.commit()
    return success_response(selected_task.serialize(), 200)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)