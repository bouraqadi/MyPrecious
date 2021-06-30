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

{ #category : #exporting }
MpReferenceConverter >> export: anObject [
	self remoteReferenceFor: anObject ifPresent: [ : existingReference | ^existingReference ].
	^self export: anObject id: self newId

]

{ #category : #exporting }
MpReferenceConverter >> export: anObject id: id [ 
	| reference |
	lock critical: [
		reference := self newRemoteReferenceWithId: id.
		exportedObjectsDict at: reference put: anObject].
	^reference
]

{ #category : #exporting }
MpReferenceConverter >> exportedObjectAt: aRemoteReference [
	^lock critical: [ 
		exportedObjectsDict
			at: aRemoteReference
			ifAbsent: [ MpUnknownObject signal ]]
]

{ #category : #initialization }
MpReferenceConverter >> initialize [
	super initialize.
	exportedObjectsDict := MpIdentityValueDictionary new.
	proxiesDict := Dictionary new.
	lock := Mutex new.

]

{ #category : #proxies }
MpReferenceConverter >> newProxyTo: remoteReference [
	^ self proxyClass transporter: self transporter remoteReference: remoteReference
]

{ #category : #exporting }
MpReferenceConverter >> newRemoteReferenceWithId: id [
	^self remoteReferenceClass 
		address: self address
		objectId: id

]

{ #category : #exporting }
MpReferenceConverter >> objectAt: aRemoteReference [
	aRemoteReference address = self address ifTrue:[ 
		^ self exportedObjectAt: aRemoteReference ].
	^ self proxyTo: aRemoteReference
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
	^self remoteReferenceFor: anObject ifAbsent: [ self export: anObject ]
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject ifAbsent: aBLock [
	^lock critical: [
		exportedObjectsDict keyAtValue: anObject ifAbsent: aBLock]
]

{ #category : #exporting }
MpReferenceConverter >> remoteReferenceFor: anObject ifPresent: aBlock [
	^lock critical: [
		exportedObjectsDict keyAtValue: anObject ifPresent: aBlock]
]

{ #category : #accessing }
MpReferenceConverter >> transporter [
	^self middleware transporter.
]
