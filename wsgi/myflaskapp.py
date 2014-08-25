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
    if data.endswith("})"):
        return "%i" % Storage.create(data=data).id
    else:
        return "nope", 404

@app.route("/dump")
def dump():
    datas = []
    for data in Storage.select():
        datas.append(data.data)
    return '\n'.join(datas)

@app.route("/Omg/<safeword>")
def loseyourmind(safeword):
    with open(os.path.join(os.environ['OPENSHIFT_DATA_DIR'],'safeword')) as file:
        safeword_cmp = file.read().strip()
    if safeword == safeword_cmp:
        for data in Storage.select():
            data.delete_instance()
        return "yay", 418
    else:
        return "nope", 403

if __name__ == "__main__":
    app.run(debug=True)

