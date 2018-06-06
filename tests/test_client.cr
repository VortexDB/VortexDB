require "../src/client/**"

DATA_PORT = 26302

client = CommonClient.new("localhost", DATA_PORT)
cls = client.createClass("Base")

sleep 10