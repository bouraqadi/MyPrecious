Class {
	#name : #MpMarshaller,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #marshalling }
MpMarshaller >> marshal: anObject [ 
	^anObject marshalWith: self
]

{ #category : #marshalling }
MpMarshaller >> marshalNormalResponse: response [ 
	| marshalledResult |
	marshalledResult := self marshal: response result.
	^response
		result: marshalledResult;
		yourself
]

{ #category : #marshalling }
MpMarshaller >> marshalObject: anObject [ 
	anObject isPassByCopy ifTrue: [ ^anObject ].
	^self remoteReferenceFor: anObject
]

{ #category : #marshalling }
MpMarshaller >> marshalRemoteMessage: message [ 
	|marshalledArgs marshalledReceiver |
	marshalledReceiver := self marshal: message receiver.
	marshalledArgs := message arguments collect: [ : each | self marshal: each ].
	^message 
		arguments: marshalledArgs;
		receiver: marshalledReceiver; 
		yourself.
]

{ #category : #marshalling }
MpMarshaller >> marshalRemoteReference: aRemoteReference [
	^aRemoteReference
]

{ #category : #marshalling }
MpMarshaller >> marshallExceptionResponse: aMmExceptionResponse [ 
	| marshalledException |
	marshalledException := MpRemoteExceptionWrapper on: aMmExceptionResponse exception.
	^aMmExceptionResponse
		exception: marshalledException;
		yourself
]

{ #category : #accessing }
MpMarshaller >> objectAt: aRemoteReference [
	^self referenceConverter objectAt: aRemoteReference
]

{ #category : #accessing }
MpMarshaller >> referenceConverter [
	^self middleware referenceConverter
]

{ #category : #accessing }
MpMarshaller >> remoteReferenceFor: anObject [ 
	^self referenceConverter remoteReferenceFor: anObject
]

{ #category : #marshalling }
MpMarshaller >> unmarshal: anObject [ 
	^anObject unmarshalWith: self
]

{ #category : #marshalling }
MpMarshaller >> unmarshalNormalResponse: response [ 
	| unmarshalledResult |
	unmarshalledResult := self unmarshal: response result.
	^response
		result: unmarshalledResult;
		yourself
]

{ #category : #marshalling }
MpMarshaller >> unmarshalObject: anObject [ 
	^anObject
]

{ #category : #marshalling }
MpMarshaller >> unmarshalRemoteMessage: message [ 
	|unmarshalledArgs unmarshalledReceiver |
	unmarshalledReceiver := self unmarshal: message receiver.
	unmarshalledArgs := message arguments collect: [ : each | self unmarshal: each ].
	^message 
		arguments: unmarshalledArgs;
		receiver: unmarshalledReceiver; 
		yourself.
]

{ #category : #marshalling }
MpMarshaller >> unmarshalRemoteReference: aRemoteReference [
	^self objectAt: aRemoteReference
]
