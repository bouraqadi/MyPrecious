Class {
	#name : #MpReferenceConverter,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'exportedObjectsDict',
		'proxiesDict',
		'lock'
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
	lock critical: [exportedObjectsDict at: reference put: anObject].
	^reference
]

{ #category : #initialization }
MpReferenceConverter >> initialize [
	super initialize.
	exportedObjectsDict := Dictionary new.
	proxiesDict := Dictionary new.
	lock := Mutex new.
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
	^lock critical: [
		exportedObjectsDict 
			at: aRemoteReference 
			ifAbsent: [ self proxyTo: aRemoteReference ]]
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
	^lock critical: [
		proxiesDict 
			at: remoteReference 
			ifAbsentPut: [ self newProxyTo: remoteReference]]
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceClass [
	^MpRemoteReference
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject [
	^exportedObjectsDict keyAtValue: anObject ifAbsent: [ self export: anObject ]
]
