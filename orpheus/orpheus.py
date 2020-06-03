from flask import Flask, render_template
from flask import request, redirect
from db_connector import connect_to_database, execute_query
from flask_bootstrap import Bootstrap


def create_app():
    app = Flask(__name__)
    Bootstrap(app)

    return app


app = create_app()


@app.route('/hello')
def hello_world():
    return 'Hello, World! Orpheus here'


@app.route('/')
def dashboard(feed=1):
    print("Fetching and rendering dashboard")
    db_connection = connect_to_database()
    query = """\
    SELECT Posts.postID, Posts.userID AS userID, username, graphic, sound, title, description, embedPostID, timeCreated, tags
    FROM Posts INNER JOIN Users ON Posts.userID = Users.userID
    LEFT JOIN Posts_Feeds ON Posts.postID = Posts_Feeds.postID
    WHERE feedID = %d""" % (feed)
    posts = execute_query(db_connection, query)

    # print(posts)

    comments = []
    for post in posts:
        postID = post[0]
        query = """\
        SELECT commentID, postID, Users.userID, username, text FROM Comments
        LEFT JOIN Users ON Comments.userID = Users.userID
        WHERE postID = %d""" % (postID)
        post_comments = execute_query(db_connection, query)
        for com in post_comments:
            comments.append(com)

    '''
    Posts indices
    ----------------------------------------------
    0      1      2        3       4
    postID userID username graphic sound
    ----------------------------------------------
    5     6           7           8           9
    title description embedPostID timeCreated tags
    ______________________________________________

    Comments indices
    ----------------------------------------------
    0         1      2      3        4
    commentID postID userID username text
    '''

    return render_template(
        'index.html',
        posts=posts,
        comments=comments
        )


# @app.route('/add_new_people', methods=['POST','GET'])
# def add_new_people():
#     db_connection = connect_to_database()
#     if request.method == 'GET':
#         query = 'SELECT id, name from bsg_planets'
#         result = execute_query(db_connection, query).fetchall()
#         print(result)
#
#         return render_template('people_add_new.html', planets = result)
#     elif request.method == 'POST':
#         print("Add new people!")
#         fname = request.form['fname']
#         lname = request.form['lname']
#         age = request.form['age']
#         homeworld = request.form['homeworld']
#
#         query = 'INSERT INTO bsg_people (fname, lname, age, homeworld) VALUES (%s,%s,%s,%s)'
#         data = (fname, lname, age, homeworld)
#         execute_query(db_connection, query, data)
#         return ('Person added!')
