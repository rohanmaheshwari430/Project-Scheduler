from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table(
    'association',
    db.Model.metadata,
    db.Column('project_id', db.Integer, db.ForeignKey('project.id')),
    db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
)


class project(db.Model):
    __tablename__ = 'project'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = False)
    tasks = db.relationship('task', cascade = 'delete')
    users = db.relationship('user', secondary = association_table, back_populates = 'projects')

    def __init__(self,**kwargs):
        self.title = kwargs.get('title')
        self.description = kwargs.get('description')

    def serialize(self):
        return {
            'id': self.id,
            "title": self.title,
            'description': self.description
        }

class task(db.Model):
    __tablename__ = 'task'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    body = db.Column(db.String, nullable = False)
    deadline = db.Column(db.String, nullable = False)
    project_id = db.Column(db.Integer, db.ForeignKey('project.id'), nullable = False)
    #how to create a relationship between tasks and users. is
    #a second association table needed? or can be done in one?
    #assigned_users = some relationship between user class and task class

    def __init__(self, **kwargs):
        self.title = kwargs.get('title')
        self.body = kwargs.get('body')
        self.deadline = kwargs.get('deadline')
        self.project_id = kwargs.get('project_id')

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'body': self.body,
            'deadline': self.deadline
        }

class user(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String, nullable = False)
    email = db.Column(db.String, nullable = False)
    projects = db.relationship('project', secondary = association_table, back_populates = 'users')
    #second half of user/task relationship goes here
    #tasks = some relationship between task and users (many to many relationship)