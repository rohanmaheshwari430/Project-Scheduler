from db import db, project, task, user
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
@app.route('/api/getProjects')
def get_projects():
    data = []
    for p in project.query.all():
        formatted_p = p.serialize()
        data.append(formatted_p)
    return success_response(data)

@app.route('/api/createProject', methods=["POST"])
def create_project():
    body = json.loads(request.data)
    if(body.get('title') == None or body.get('description') == None):
        return failure_response('One or more fields is missing.')
    else:
        new_project = project(title = body.get('title'), description = body.get('description'))
        db.session.add(new_project)
        db.session.commit()
        formatted_project = new_project.serialize()
        formatted_project['tasks'] = [t.serialize() for t in task.query.filter_by(project_id = formatted_project.get('id')).all()]
        formatted_project['users'] = [u.serialize() for u in new_project.users]
        return success_response(formatted_project, 201)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)