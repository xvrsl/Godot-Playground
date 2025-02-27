extends Node
class_name NetworkManager

@export var status : Status

enum Status
{
	None = 0,
	Host = 1,
	Client = 2
}

func server(port:int=23333):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	
func client(ip: String, port:int=23333):
	var peer =ENetMultiplayerPeer.new()
	peer.create_client(ip,port)
