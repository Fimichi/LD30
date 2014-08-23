from flask import Flask
from peewee import *
from flask_peewee.db import Database
import os

DATABASE = {
    'name': os.path.join(os.environ['OPENSHIFT_DATA_DIR'],'fimichi.sqlite'),
    'engine': 'peewee.SqliteDatabase' 
}

app = Flask(__name__)
app.config.from_object(__name__)
db = Database(app)

class Storage(db.Model):
    data = TextField()

Storage.create_table(fail_silently=True)

@app.route("/store/<data>")
def store(data):
    return "%i" % Storage.create(data=data).id    

@app.route("/dump")
def dump():
    datas = []
    for data in Storage.select():
        datas.append(data.data)
    return '\n'.join(datas)

@app.route("/OmgFinnbarIsSoAwesome"):
def loseyourmind():
    for data in Storage.select():
        data.delete_instance()

if __name__ == "__main__":
    app.run()

