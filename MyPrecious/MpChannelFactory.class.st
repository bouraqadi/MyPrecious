Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactory >> inboundChannel [
	^self newInboundChannel
]

{ #category : #communicating }
MpChannelFactory >> inboundChannelClass [
	self subclassResponsibility
]

{ #category : #communicating }
MpChannelFactory >> newInboundChannel [
	^self inboundChannelClass middleware: self middleware
]

{ #category : #communicating }
MpChannelFactory >> newOutboundChannelTo: remoteReference [
	^self outboundChannelClass middleware: self middleware

]

{ #category : #communicating }
MpChannelFactory >> outboundChannelClass [
	self subclassResponsibility
]

{ #category : #communicating }
MpChannelFactory >> outboundChannelTo: remoteReference [
	^self newOutboundChannelTo: remoteReference

]

{ #category : #accessing }
MpChannelFactory >> referenceConverter [
	^self middleware referenceConverter.
]
