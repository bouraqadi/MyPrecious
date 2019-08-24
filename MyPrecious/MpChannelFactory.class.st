Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactory >> channelClass [
	self subclassResponsibility
]

{ #category : #communicating }
MpChannelFactory >> channelTo: remoteReference [
	^self subclassResponsibility
]

{ #category : #communicating }
MpChannelFactory >> newChannel [
	^self channelClass middleware: self middleware
]

{ #category : #accessing }
MpChannelFactory >> referenceConverter [
	^self middleware referenceConverter.
]
