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
MpWebMiddleware >> defaultProtocol [
	^MpWebFullAddress http
]

{ #category : #initialization }
MpWebMiddleware >> initialize [
	super initialize.
	self protocol: self defaultProtocol
]

{ #category : #initialization }
MpWebMiddleware >> protocol: webProtocol [
	^self address protocol: webProtocol
]

{ #category : #initialization }
MpWebMiddleware >> transporterClass [
	^MpWebConnectedTransporter
]
