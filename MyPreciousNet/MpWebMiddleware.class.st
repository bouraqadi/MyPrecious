Class {
	#name : #MpWebMiddleware,
	#superclass : #MpMiddleware,
	#traits : 'MpTNetMiddleware',
	#classTraits : 'MpTNetMiddleware classTrait',
	#category : #'MyPreciousNet-Web'
}

{ #category : #initialization }
MpWebMiddleware >> addressClass [
	^MpWebFullAddress  
]

{ #category : #initialization }
MpWebMiddleware >> protocol: webProtocol [
	^self address protocol: webProtocol
]

{ #category : #initialization }
MpWebMiddleware >> transporterClass [
	^MpWebConnectedTransporter
]
