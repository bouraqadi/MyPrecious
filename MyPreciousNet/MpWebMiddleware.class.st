Class {
	#name : #MpWebMiddleware,
	#superclass : #MpTcpMiddleware,
	#category : #'MyPreciousNet-Web'
}

{ #category : #initialization }
MpWebMiddleware >> transporterClass [
	^MpWebConnectedTransporter
]
