require "../src/client/**"

DATA_PORT = 26302

client = CommonClient.new("localhost", DATA_PORT)
client.open
bcls = client.createClass("Base").wait
inst = client.createInstance(bcls.not_nil!.name).wait
p inst
