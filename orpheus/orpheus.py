from flask import Flask, render_template
from flask import request, redirect
import MySQLdb as my
from db_connector import connect_to_database, execute_query
from flask_bootstrap import Bootstrap


def create_app():
    app = Flask(__name__)
    Bootstrap(app)

    return app


app = create_app()


def get_feed(user):
    db_connection = connect_to_database()
    query = 'SELECT feedID, interests from ContentFeeds WHERE userID = %d' % (user)
    feed = execute_query(db_connection, query).fetchone()
    return feed

def add_to_feed(post, feed):
    db_connection = connect_to_database()
    try:
        query = 'INSERT INTO Posts_Feeds(postID, feedID) VALUES (%s,%s)'
        data = (post, feed)
        execute_query(db_connection, query, data)
    except my.IntegrityError as e:
        print("IntegrityError")
        print(e)


@app.route('/hello')
def hello_world():
    return 'Hello, World! Orpheus here'


@app.route('/')
def index():
    user = 1
    return redirect('/%s' % (user))


@app.route('/<int:user>')
def dashboard(user=1):
    print("Fetching and rendering dashboard")
    db_connection = connect_to_database()

    feed = get_feed(user)

    query = "SELECT postID FROM Posts \
    WHERE description LIKE '%%%%%s%%%%' || title LIKE '%%%%%s%%%%' || tags LIKE '%%%%%s%%%%'" \
    % (feed[1], feed[1], feed[1])
    posts = execute_query(db_connection, query)

    for post in posts:
        add_to_feed(post, feed[0])

    query = """\
    SELECT Posts.postID, Posts.userID AS userID, username, graphic, sound,
    title, description, embedPostID, timeCreated, tags
    FROM Posts INNER JOIN Users ON Posts.userID = Users.userID
    LEFT JOIN Posts_Feeds ON Posts.postID = Posts_Feeds.postID
    WHERE feedID = %d ORDER BY timeCreated DESC""" % (feed[0])
    posts = execute_query(db_connection, query)

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
        comments=comments,
        user=user
        )


@app.route('/<int:user>/add_post', methods=['POST'])
def add_post(user=1):

    db_connection = connect_to_database()
    graphic = request.form['graphic']
    sound = request.form['sound']
    title = request.form['title']
    description = request.form['description']
    embedPostID = request.form['embed']
    tags = request.form['tags']

    query = '''
    INSERT INTO Posts(userID, graphic, sound, title, description, embedPostID, tags)
    VALUES (%s,%s,%s,%s,%s,%s,%s)
    '''
    data = (user, graphic, sound, title, description, embedPostID, tags)
    execute_query(db_connection, query, data)
    print('posted!')

    query = '''SELECT postID FROM Posts ORDER BY postID DESC LIMIT 1'''
    post = execute_query(db_connection, query).fetchone()
    feed = get_feed(user)

    add_to_feed(post[0], feed[0])

    return redirect('/%s' % (user))


@app.route('/<int:user>/<int:post>/add_comment', methods=['POST'])
def add_comment(post, user=1):

    db_connection = connect_to_database()
    comment = request.form['comment']

    query = '''
    INSERT INTO Comments(postID, userID, text)
    VALUES (%s,%s,%s)
    '''
    data = (post, user, comment)
    execute_query(db_connection, query, data)

    print('comment posted!')

    return redirect('/%s#%s' % (user, post))


def get_userID(username):
    db_connection = connect_to_database()
    query = "SELECT userID from Users WHERE username = '%s' " % (username)
    userID = execute_query(db_connection, query).fetchone()
    return userID


@app.route('/users/<string:username>')
def profile(username):
    print("Fetching and rendering user Profile")
    db_connection = connect_to_database()

    query = "SELECT userID, username, password, email FROM Users WHERE username= '%s' " % (username)
    userdata = execute_query(db_connection, query).fetchone()

    print(userdata)
    user_id = get_userID(username);
    print("userID = %s" % user_id);

    query = """\
    SELECT Posts.postID, Posts.userID AS userID, username, graphic, sound,
    title, description, embedPostID, timeCreated, tags
    FROM Posts INNER JOIN Users ON Posts.userID = Users.userID
    WHERE Posts.userID = %d ORDER BY timeCreated DESC""" % (user_id);

    posts = execute_query(db_connection, query).fetchall()
    print(posts)

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




    return render_template('profile.html', userdata=userdata,
    posts=posts,
    comments=comments,
    user=user_id
    );

  
@app.route('/<int:user>/<int:post>/update_post', methods=['POST','GET'])

def update_post(user, post):

    db_connection = connect_to_database()

    if request.method == 'GET':

        query = """\
        SELECT Posts.postID, Posts.userID AS userID, username, graphic, sound,
        title, description, embedPostID, timeCreated, tags
        FROM Posts INNER JOIN Users ON Posts.userID = Users.userID
        LEFT JOIN Posts_Feeds ON Posts.postID = Posts_Feeds.postID
        WHERE Posts.postID = %d""" % (post)
        post = execute_query(db_connection, query).fetchone()

        if post is None:
            return "Post not found."

        comments = []
        postID = post[0]
        query = """\
        SELECT commentID, postID, Users.userID, username, text FROM Comments
        LEFT JOIN Users ON Comments.userID = Users.userID
        WHERE postID = %d""" % (postID)
        post_comments = execute_query(db_connection, query)
        for com in post_comments:
            comments.append(com)

        return render_template(
            'edit-post.html',
            post=post,
            comments=comments
            )

    elif request.method == 'POST':
        print('The POST request')
        graphic = request.form['graphic']
        sound = request.form['sound']
        title = request.form['title']
        description = request.form['description']
        embedPostID = request.form['embed']
        tags = request.form['tags']

        query = "UPDATE Posts SET graphic = %s, sound = %s, title = %s, description = %s, embedPostID = %s, tags = %s WHERE postID = %s"
        data = (graphic, sound, title, description, embedPostID, tags, post)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + " row(s) updated")

        return redirect('/%s#%s' % (user, post))
