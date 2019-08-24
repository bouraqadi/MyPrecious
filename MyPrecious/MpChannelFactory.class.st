Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactory >> channelClass [
	^self middleware channelClass

]

{ #category : #communicating }
MpChannelFactory >> channelTo: remoteReference [
	^self subclassResponsibility
]

{ #category : #communicating }
MpChannelFactory >> newChannel [
	^self channelClass middleware: self middleware
]
