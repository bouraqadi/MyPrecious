Extension { #name : #ProtoObject }

{ #category : #'*MyPrecious' }
ProtoObject >> actualClass [
	^self class
]

{ #category : #'*MyPrecious' }
ProtoObject >> isPassByCopy [
	^false
]

{ #category : #'*MyPrecious' }
ProtoObject >> isPassByReference [
	^self isPassByCopy not
]

{ #category : #'*MyPrecious' }
ProtoObject >> marshalWith: aMarshaller [
	^aMarshaller marshalObject: self
]

{ #category : #'*MyPrecious' }
ProtoObject >> unmarshalWith: aMarshaller [
	^aMarshaller unmarshalObject: self
]
