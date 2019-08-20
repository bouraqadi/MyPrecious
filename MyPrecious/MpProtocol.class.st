Class {
	#name : #MpProtocol,
	#superclass : #Object,
	#category : #'MyPrecious-Kernel'
}

{ #category : #serializing }
MpProtocol >> materializeFromByteArray: anObject [
	^FLMaterializer materializeFromByteArray: anObject
]

{ #category : #serializing }
MpProtocol >> serializeToByteArray: anObject [
	^FLSerializer serializeToByteArray: anObject
]
