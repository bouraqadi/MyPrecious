Class {
	#name : #MpMiddleware,
	#superclass : #Object,
	#instVars : [
		'marshaller',
		'referenceConverter',
		'address',
		'waitForResultTimeoutDuration',
		'transporter'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpMiddleware >> address [
	^address
]

{ #category : #accessing }
MpMiddleware >> address: anAddress [
	address := anAddress 
]

{ #category : #initialization }
MpMiddleware >> defaultReceptionServicePriority [
	^Processor userInterruptPriority 
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

{ #category : #initialization }
MpMiddleware >> initialize [
	super initialize.
	referenceConverter := self referenceConverterClass middleware: self.
	marshaller := self marshallerClass middleware: self.
	transporter := self transporterClass middleware: self.
	self waitForResultTimeoutDuration: self defaultWaitForResultTimeoutDuration.
	self receptionServicePriority: self defaultReceptionServicePriority.
]

{ #category : #activity }
MpMiddleware >> isStarted [
	^self transporter isStarted
]

{ #category : #activity }
MpMiddleware >> isStopped [
	^self transporter isStopped
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

{ #category : #printing }
MpMiddleware >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< ' (';
		print: self address;
		<<$)
]

{ #category : #initialization }
MpMiddleware >> proxyClass [
	^MpProxy
]

{ #category : #activity }
MpMiddleware >> receptionServicePriority: anInteger [
	self transporter receptionServicePriority: anInteger
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

{ #category : #messaging }
MpMiddleware >> send: selector arguments: args to: targetRemoteReference [ 
	^self transporter send: selector arguments: args to: targetRemoteReference
]

{ #category : #messaging }
MpMiddleware >> send: selector to: remoteReference [ 
	^self transporter send: selector to: remoteReference.
]

{ #category : #messaging }
MpMiddleware >> sendAsync: selector arguments: args to: targetRemoteReference [
	self transporter 
		sendAsync: selector 
		arguments: args 
		to: targetRemoteReference
]

{ #category : #messaging }
MpMiddleware >> sendAsync: selector to: targetRemoteReference [ 
	self transporter sendAsync: selector to: targetRemoteReference.
]

{ #category : #activity }
MpMiddleware >> start [
	self transporter start
]

{ #category : #activity }
MpMiddleware >> stop [
	self transporter stop
]

{ #category : #accessing }
MpMiddleware >> transporter [
	^transporter
]

{ #category : #initialization }
MpMiddleware >> transporterClass [
	^MpTransporter
]

{ #category : #accessing }
MpMiddleware >> waitForResultTimeoutDuration [
	^waitForResultTimeoutDuration
]

{ #category : #accessing }
MpMiddleware >> waitForResultTimeoutDuration: anObject [
	waitForResultTimeoutDuration := anObject
]
