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
