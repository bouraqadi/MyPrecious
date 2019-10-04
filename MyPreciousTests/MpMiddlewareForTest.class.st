Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#classVars : [
		'AddressCounter',
		'Registry'
	],
	#category : #'MyPreciousTests-Common'
}

{ #category : #accessing }
MpMiddlewareForTest >> address: anAddress [
	super address: anAddress.
	self registry at: anAddress put: self transporter
]

{ #category : #initialization }
MpMiddlewareForTest >> initialize [
	super initialize.
	self address: self newAddress
]

{ #category : #accessing }
MpMiddlewareForTest >> newAddress [
	| previousCount |
	previousCount := AddressCounter ifNil: [AddressCounter := 0].
	AddressCounter := previousCount + 1.
	^String streamContents: [: str |
		str << self className; print: AddressCounter]
]

{ #category : #accessing }
MpMiddlewareForTest >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]
