Class {
	#name : #MpTcpConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#traits : 'MpTTcpTransporter',
	#classTraits : 'MpTTcpTransporter classTrait',
	#category : #MyPreciousTcp
}

{ #category : #connecting }
MpTcpConnectedTransporter >> connectionClass [
	^MpTcpOneShotConnection
]
