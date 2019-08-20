Class {
	#name : #MpMiddleware,
	#superclass : #Object,
	#instVars : [
		'outboundChannelsDict',
		'exportedObjectsDict',
		'marshaller',
		'proxiesDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #exporting }
MpMiddleware >> export: anObject [
	^self export: anObject id: self newExportId
]

{ #category : #exporting }
MpMiddleware >> export: anObject id: id [ 
	| reference |
	reference := self newRemoteReferenceWithId: id.
	exportedObjectsDict at: reference put: anObject.
	^reference
]

{ #category : #exporting }
MpMiddleware >> exportedObjectsDict [
	^exportedObjectsDict
]

{ #category : #initialization }
MpMiddleware >> initialize [
	super initialize.
	exportedObjectsDict := Dictionary new.
	proxiesDict := Dictionary new.
	marshaller := self marshallerClass new.
	marshaller middleware: self
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
MpMiddleware >> newExportId [
	^UUID new asString
]

{ #category : #proxies }
MpMiddleware >> newProxyTo: remoteReference [
	| channel |
	channel := self outboundChannelTo: remoteReference.
	^ self newProxyVia: channel to: remoteReference
]

{ #category : #proxies }
MpMiddleware >> newProxyVia: channel to: remoteReference [
	^ MpProxy channel: channel remoteReference: remoteReference
]

{ #category : #exporting }
MpMiddleware >> newRemoteReferenceWithId: id [
	^self remoteReferenceClass new
		objectId: id;
		yourself
]

{ #category : #exporting }
MpMiddleware >> objectAt: aRemoteReference [
	^self exportedObjectsDict at: aRemoteReference ifAbsent: [ self proxyAt: aRemoteReference ]
]

{ #category : #communicating }
MpMiddleware >> outboundChannelClass [
	self subclassResponsibility
]

{ #category : #communicating }
MpMiddleware >> outboundChannelTo: remoteReference [
	^self outboundChannelClass new
				middleware: self
				yourself
]

{ #category : #'as yet unclassified' }
MpMiddleware >> proxyAt: remoteReference [ 
	^proxiesDict at: remoteReference ifAbsentPut: [ self newProxyTo: remoteReference]
]

{ #category : #proxies }
MpMiddleware >> proxyAtId: id [
	| reference |
	reference := self newRemoteReferenceWithId: id.
	^self newProxyTo: reference
]

{ #category : #exporting }
MpMiddleware >> remoteReferenceClass [
	^MpRemoteReference
]

{ #category : #exporting }
MpMiddleware >> remoteReferenceFor: anObject [
	^self exportedObjectsDict keyAtValue: anObject ifAbsent: [ self export: anObject ]
]
