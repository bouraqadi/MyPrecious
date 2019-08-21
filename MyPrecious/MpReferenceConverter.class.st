Class {
	#name : #MpReferenceConverter,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'exportedObjectsDict',
		'proxiesDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpReferenceConverter >> channelFactory [
	^self middleware channelFactory.
]

{ #category : #exporting }
MpReferenceConverter >> export: anObject [
	^self export: anObject id: self newExportId
]

{ #category : #exporting }
MpReferenceConverter >> export: anObject id: id [ 
	| reference |
	reference := self newRemoteReferenceWithId: id.
	exportedObjectsDict at: reference put: anObject.
	^reference
]

{ #category : #exporting }
MpReferenceConverter >> exportedObjectsDict [
	^exportedObjectsDict
]

{ #category : #initialization }
MpReferenceConverter >> initialize [
	super initialize.
	exportedObjectsDict := Dictionary new.
	proxiesDict := Dictionary new.

]

{ #category : #exporting }
MpReferenceConverter >> newExportId [
	^UUID new asString
]

{ #category : #proxies }
MpReferenceConverter >> newProxyTo: remoteReference [
	| channel |
	channel := self outboundChannelTo: remoteReference.
	^ self newProxyTo: remoteReference channel: channel
]

{ #category : #proxies }
MpReferenceConverter >> newProxyTo: remoteReference channel: channel [
	^ self proxyClass channel: channel remoteReference: remoteReference
]

{ #category : #exporting }
MpReferenceConverter >> newRemoteReferenceWithId: id [
	^self remoteReferenceClass new
		objectId: id;
		yourself
]

{ #category : #exporting }
MpReferenceConverter >> objectAt: aRemoteReference [
	^self exportedObjectsDict at: aRemoteReference ifAbsent: [ self proxyTo: aRemoteReference ]
]

{ #category : #proxies }
MpReferenceConverter >> outboundChannelTo: remoteReference [ 
	^self channelFactory outboundChannelTo: remoteReference
]

{ #category : #proxies }
MpReferenceConverter >> proxyClass [
	^MpProxy
]

{ #category : #proxies }
MpReferenceConverter >> proxyTo: remoteReference [ 
	^proxiesDict at: remoteReference ifAbsentPut: [ self newProxyTo: remoteReference]
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceClass [
	^MpRemoteReference
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject [
	^self exportedObjectsDict keyAtValue: anObject ifAbsent: [ self export: anObject ]
]
