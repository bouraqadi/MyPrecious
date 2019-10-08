Class {
	#name : #MpMiddleware,
	#superclass : #Object,
	#instVars : [
		'marshaller',
		'referenceConverter',
		'address',
		'transporter',
		'receptionTimeoutDuration',
		'processingPriority'
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
MpMiddleware >> defaultProcessingPriority [
	^Processor userSchedulingPriority
]

{ #category : #initialization }
MpMiddleware >> defaultReceptionPriority [
	^Processor userBackgroundPriority
]

{ #category : #initialization }
MpMiddleware >> defaultReceptionTimeoutDuration [
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
	self receptionTimeoutDuration: self defaultReceptionTimeoutDuration.
	self 
		receptionPriority: self defaultReceptionPriority
		processingPriority: self defaultProcessingPriority 
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

{ #category : #activity }
MpMiddleware >> processingPriority [
	^processingPriority
]

{ #category : #initialization }
MpMiddleware >> proxyClass [
	^MpProxy
]

{ #category : #activity }
MpMiddleware >> receptionPriority [
	^self transporter receptionPriority
]

{ #category : #activity }
MpMiddleware >> receptionPriority: newReceptionPriority processingPriority: newProcessingPriority [
	newReceptionPriority < newProcessingPriority ifFalse: [ 
		self error: 'Processing priority should be greater than reception priority' ].
	self transporter receptionPriority: newReceptionPriority.
	processingPriority  := newProcessingPriority
]

{ #category : #accessing }
MpMiddleware >> receptionTimeoutDuration [
	^receptionTimeoutDuration
]

{ #category : #accessing }
MpMiddleware >> receptionTimeoutDuration: anObject [
	receptionTimeoutDuration := anObject
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
	^self subclassResponsibility
]
