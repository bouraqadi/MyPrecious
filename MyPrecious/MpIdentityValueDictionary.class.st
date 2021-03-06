Class {
	#name : #MpIdentityValueDictionary,
	#superclass : #Dictionary,
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpIdentityValueDictionary >> keyAtValue: value ifAbsent: exceptionBlock [
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer the result of evaluating exceptionBlock.
	: Use  ==, and not = because exported objects are passed by reference"
 
	self associationsDo: 
		[:association | value == association value ifTrue: [^association key]].
	^exceptionBlock value
]

{ #category : #accessing }
MpIdentityValueDictionary >> keyAtValue: value ifPresent: aBlock [
	| key |
	key := self keyAtValue: value ifAbsent: [^self].
	^aBlock cull: key
]
