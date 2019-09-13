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
MpValueHolderForTest >> contents [
	^ contents
]

{ #category : #accessing }
MpValueHolderForTest >> contents: anObject [
	contents := anObject
]
