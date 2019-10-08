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
MpMiddlewareForTest class >> addressCounter [
	^ AddressCounter ifNil: [ AddressCounter := 0 ]
]

{ #category : #accessing }
MpMiddlewareForTest class >> addressCounter: newCount [
	AddressCounter := newCount
]

{ #category : #accessing }
MpMiddlewareForTest class >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]

{ #category : #initialization }
MpMiddlewareForTest class >> resetRegistry [ 	
	<script>
	AddressCounter := nil.
	Registry := nil
]

{ #category : #accessing }
MpMiddlewareForTest >> address: anAddress [
	super address: anAddress.
	self registry at: anAddress put: self transporter
]

{ #category : #accessing }
MpMiddlewareForTest >> addressCounter [
	^self class addressCounter
]

{ #category : #accessing }
MpMiddlewareForTest >> addressCounter: newCount [
	self class addressCounter: newCount
]

{ #category : #initialization }
MpMiddlewareForTest >> initialize [
	super initialize.
	self address: self newAddress
]

{ #category : #accessing }
MpMiddlewareForTest >> newAddress [
	| previousCount currentCount|
	previousCount := self addressCounter.
	currentCount := previousCount + 1.
	self addressCounter: currentCount.
	^ String
		streamContents: [ :str | 
			str
				<< self className;
				print: currentCount ]
]

{ #category : #accessing }
MpMiddlewareForTest >> registry [
	^self class registry
]
