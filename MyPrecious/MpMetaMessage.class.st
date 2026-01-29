Class {
	#name : 'MpMetaMessage',
	#superclass : 'Object',
	#category : 'MyPrecious-Connected',
	#package : 'MyPrecious',
	#tag : 'Connected'
}

{ #category : 'communicating' }
MpMetaMessage >> deliverBy: transporter [
	self subclassResponsibility
]

{ #category : 'testing' }
MpMetaMessage >> isPassByCopy [
	^true
]
