Class {
	#name : 'MpWebConnectedTransporter',
	#superclass : 'MpTcpConnectedTransporter',
	#category : 'MyPreciousNet-Web',
	#package : 'MyPreciousNet',
	#tag : 'Web'
}

{ #category : 'connecting' }
MpWebConnectedTransporter >> connectionClass [
	^MpWebConnection
]

{ #category : 'initialization' }
MpWebConnectedTransporter >> serverClass [
	^MpWebServer 
]
