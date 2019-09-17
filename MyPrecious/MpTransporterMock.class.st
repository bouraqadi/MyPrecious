Class {
	#name : #MpTransporterMock,
	#superclass : #Object,
	#instVars : [
		'messageAnswersDict'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpTransporterMock >> initialize [
	super initialize.
	messageAnswersDict := Dictionary new
]

{ #category : #initialization }
MpTransporterMock >> selector: selector answer: answer [ 
	messageAnswersDict
		at: selector
		put: answer
]

{ #category : #communicating }
MpTransporterMock >> sendMessage: localMessage targetReference: remoteReference receiver: aProxy [
	| response selector |
	selector := localMessage selector.
	response := messageAnswersDict 
		at: selector 
		ifAbsent: [MessageNotUnderstood signal: 'Proxy doesNotUnderstand: #', selector].
	^response value
]
