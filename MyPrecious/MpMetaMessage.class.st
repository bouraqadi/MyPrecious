Class {
	#name : #MpMetaMessage,
	#superclass : #Object,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpMetaMessage >> deliverBy: transporter [
	self subclassResponsibility
]

{ #category : #testing }
MpMetaMessage >> isPassByCopy [
	^true
]
