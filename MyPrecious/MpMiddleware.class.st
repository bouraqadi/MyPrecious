Class {
	#name : #MpMiddleware,
	#superclass : #Object,
	#instVars : [
		'marshaller',
		'referenceConverter',
		'channelFactory',
		'address',
		'waitForResultTimeoutDuration'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpMiddleware >> address [
	^address
]

{ #category : #initialization }
MpMiddleware >> channelClass [
	self subclassResponsibility
]

{ #category : #accessing }
MpMiddleware >> channelFactory [
	^ channelFactory
]

{ #category : #initialization }
MpMiddleware >> channelFactoryClass [
	^self subclassResponsibility
]

{ #category : #initialization }
MpMiddleware >> defaultWaitForResultTimeoutDuration [
	^500 milliSeconds 
]

{ #category : #exporting }
MpMiddleware >> export: anObject [ 
	^self referenceConverter export: anObject
]

{ #category : #exporting }
MpMiddleware >> export: anObject id: aString [ 
	^self referenceConverter export: anObject id: aString 
]

{ #category : #communicating }
MpMiddleware >> inboundChannelWith: anObject [
	^self channelFactory inboundChannelWith: anObject
]

{ #category : #communicating }
MpMiddleware >> inboundChannels [
	^self channelFactory inboundChannels
]

{ #category : #initialization }
MpMiddleware >> initialize [
	super initialize.
	referenceConverter := self referenceConverterClass middleware: self.
	marshaller := self marshallerClass middleware: self.
	channelFactory := self channelFactoryClass middleware: self.
	self waitForResultTimeoutDuration: self defaultWaitForResultTimeoutDuration
]

{ #category : #accessing }
MpMiddleware >> marshaller [
	^ marshaller
]

{ #category : #initialization }
MpMiddleware >> marshallerClass [
	^MpMarshaller
]

{ #category : #exporting }
MpMiddleware >> objectAt: remoteReference [
	^self referenceConverter objectAt: remoteReference
]

{ #category : #communicating }
MpMiddleware >> outboundChannelTo: remoteReference [
	^self channelFactory outboundChannelTo: remoteReference
]

{ #category : #communicating }
MpMiddleware >> outboundChannelsDict [
	^self channelFactory outboundChannelsDict
]

{ #category : #initialization }
MpMiddleware >> proxyClass [
	^MpProxy
]

{ #category : #proxies }
MpMiddleware >> proxyTo: remoteReference [ 
	^self referenceConverter proxyTo: remoteReference 
]

{ #category : #accessing }
MpMiddleware >> referenceConverter [
	^ referenceConverter
]

{ #category : #initialization }
MpMiddleware >> referenceConverterClass [
	^MpReferenceConverter
]

{ #category : #exporting }
MpMiddleware >> remoteReferenceClass [
	^MpRemoteReference
]

{ #category : #exporting }
MpMiddleware >> remoteReferenceFor: anObject [
	^self referenceConverter remoteReferenceFor: anObject
]

{ #category : #communicating }
MpMiddleware >> waitForResultTimeoutDuration [
	^waitForResultTimeoutDuration
]

{ #category : #accessing }
MpMiddleware >> waitForResultTimeoutDuration: anObject [
	waitForResultTimeoutDuration := anObject
]
