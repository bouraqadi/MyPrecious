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
MpReferenceConverter >> address [
	^self middleware address
]

{ #category : #accessing }
MpReferenceConverter >> channelFactory [
	^self middleware channelFactory.
]

{ #category : #exporting }
MpReferenceConverter >> export: anObject [
	lock critical: [
		self remoteReferenceFor: anObject ifPresent: [ : existingReference | ^existingReference ].
		^self export: anObject id: self newId
	]
]

{ #category : #exporting }
MpReferenceConverter >> export: anObject id: id [ 
	| reference |
	lock critical: [
		reference := self newRemoteReferenceWithId: id.
		exportedObjectsDict at: reference put: anObject].
	^reference
]

{ #category : #initialization }
MpReferenceConverter >> initialize [
	super initialize.
	exportedObjectsDict := MpIdentityValueDictionary new.
	proxiesDict := Dictionary new.
	lock := Mutex new.
]

{ #category : #proxies }
MpReferenceConverter >> newOutboundChannelTo: remoteReference [ 
	^self channelFactory outboundChannelTo: remoteReference
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
		address: self address;
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
	^self middleware proxyClass
]

{ #category : #proxies }
MpReferenceConverter >> proxyTo: remoteReference [ 
	^lock critical: [
		proxiesDict 
			at: remoteReference 
			ifAbsentPut: [ self newProxyTo: remoteReference]]
]

{ #category : #initialization }
MpReferenceConverter >> remoteReferenceClass [
	^self middleware remoteReferenceClass
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject [
	^exportedObjectsDict keyAtValue: anObject ifAbsent: [ self export: anObject ]
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject ifPresent: aBlock [
	^exportedObjectsDict keyAtValue: anObject ifPresent: aBlock
]
