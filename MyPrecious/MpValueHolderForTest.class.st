Class {
	#name : #MpValueHolderForTest,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'contents'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpValueHolderForTest >> chainSize [
	self contents ifNil: [ ^1 ].
	^1 + contents chainSize 
]

{ #category : #accessing }
MpValueHolderForTest >> contents [
	^ contents
]

{ #category : #accessing }
MpValueHolderForTest >> contents: anObject [
	contents := anObject
]
