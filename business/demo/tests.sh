curl -X POST -H "Content-Type: application/json" -d '{"username": "user1", "passwdString": "hahaha"}' http://localhost:8080/demo/user/register
curl -X POST -H "Content-Type: application/json" -d '{"username": "user2", "passwdString": "sdfghjk"}' http://localhost:8080/demo/user/register
curl -X POST -H "Content-Type: application/json" -d '{"name": "album1", "description": "nice pics", "restrictMode": 2}' http://localhost:8080/demo/album/add
curl -X POST -H "Content-Type: application/json" -d '{"name": "2", "description": "nice pics", "restrictMode": 3}' http://localhost:8080/demo/album/add
curl -X POST -H "Content-Type: application/json" -d '{"name": "##", "description": "aahahha", "restrictMode": 1}' http://localhost:8080/demo/album/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=3" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=3" -F "face=true" http://localhost:8080/demo/image/add
curl -X DELETE http://localhost:8080/demo/album/delete/3
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=1" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=1" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=1" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=1" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=1" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -F "path=@./testpic/avagz.jpg" -F "albumId=2" -F "face=true" http://localhost:8080/demo/image/add
curl -X POST -H "Content-Type: application/json" -d '[2,4,5,6,8,9,11]' http://localhost:8080/demo/album/move\?from\=1\&to\=2
curl -X GET http://localhost:8080/demo/album/1 
curl -X GET http://localhost:8080/demo/album/2
curl -X GET http://localhost:8080/demo/album/3
curl -X DELETE http://localhost:8080/demo/image/delete/2
curl -X DELETE http://localhost:8080/demo/image/delete/4
curl -X POST -H "Content-Type: application/json" -d '{"username": "user1", "picId": 9, "text": "nice pic!!"}' http://localhost:8080/demo/image/comment
curl -X POST -H "Content-Type: application/json" -d '{"username": "user2", "picId": 9, "text": "drop table users;"}' http://localhost:8080/demo/image/comment
curl -X GET http://localhost:8080/demo/image/9/comments


