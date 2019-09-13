Class {
	#name : #MpChannelMock,
	#superclass : #Object,
	#instVars : [
		'messageAnswersDict'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpChannelMock >> initialize [
	super initialize.
	messageAnswersDict := Dictionary new
]

{ #category : #initialization }
MpChannelMock >> selector: selector answer: answer [ 
	messageAnswersDict
		at: selector
		put: answer
]

{ #category : #communicating }
MpChannelMock >> sendMessageSynchronously: aMessage to: receiver [
	| response selector |
	selector := aMessage selector.
	response := messageAnswersDict 
		at: selector 
		ifAbsent: [MessageNotUnderstood signal: 'Proxy doesNotUnderstand: #', selector].
	^response value
]
