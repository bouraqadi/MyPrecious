Class {
	#name : #MpTcpMiddleware,
	#superclass : #MpMiddleware,
	#traits : 'MpTNetMiddleware',
	#classTraits : 'MpTNetMiddleware classTrait',
	#category : #'MyPreciousNet-Tcp'
}

{ #category : #initialization }
MpTcpMiddleware >> addressClass [
	^MpIpFullAddress 
]

{ #category : #initialization }
MpTcpMiddleware >> transporterClass [
	^MpTcpConnectedTransporter
]
