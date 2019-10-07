Class {
	#name : #MpTcpConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#traits : 'MpTTcpTransporter',
	#classTraits : 'MpTTcpTransporter classTrait',
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpConnectedTransporter >> startServiceReceivingFromStream: stream [
	[self receiveBytesFromStream: stream] fork
]
