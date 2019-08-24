Class {
	#name : #MpMiddleware,
	#superclass : #Object,
	#instVars : [
		'marshaller',
		'referenceConverter',
		'channelFactory',
		'address'
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
	channelFactory := self channelFactoryClass middleware: self.
]

{ #category : #accessing }
MpMiddleware >> marshaller [
	^ marshaller
]

{ #category : #initialization }
MpMiddleware >> marshallerClass [
	^MpMarshaller
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
