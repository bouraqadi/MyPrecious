Class {
	#name : #MpWebConnectedTransporter,
	#superclass : #MpTcpConnectedTransporter,
	#category : #'MyPreciousNet-Web'
}

{ #category : #connecting }
MpWebConnectedTransporter >> connectionClass [
	^MpWebConnection
]

{ #category : #initialization }
MpWebConnectedTransporter >> serverClass [
	^MpWebServer 
]
