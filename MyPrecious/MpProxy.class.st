Class {
	#name : #MpProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'remoteReference',
		'isDebugging',
		'transporter'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProxy class >> transporter: aTransporter remoteReference: aRemoteReference [
	^ self new
		transporter: aTransporter remoteReference: aRemoteReference;
		yourself
]

{ #category : #'class membership' }
MpProxy >> basicClass [
	| message |
	isDebugging ifTrue: [ ^ super class ]. "Make it possible to debug + avoid infinite debuggers"
	message := Message selector: #class.
	^ self doesNotUnderstand: message
]

{ #category : #'class membership' }
MpProxy >> basicSpecies [

	^ self basicClass 
]

{ #category : #'class membership' }
MpProxy >> class [

	isDebugging ifTrue: [ ^ super class ]. "Make it possible to debug + avoid infinite debuggers"
	^ Smalltalk at: self className ifAbsent: [ self basicClass ]
]

{ #category : #'class membership' }
MpProxy >> className [

	| message |
	message := Message selector: #className.
	^ (self doesNotUnderstand: message) asSymbol
]

{ #category : #'reflective operations' }
MpProxy >> doesNotUnderstand: aMessage [

	| result |
	result := [ 
	          transporter
		          send: aMessage selector
		          arguments: aMessage arguments
		          to: remoteReference ]
		          on: Error
		          do: [ :ex | 
			          isDebugging := true.
			          ex pass ].
	isDebugging := false.
	^ result
]

{ #category : #'initialize-release' }
MpProxy >> initialize [
	super initialize.
	isDebugging := false.
]

{ #category : #'class membership' }
MpProxy >> isKindOf: aClass [

	"Answer whether the class, aClass, is a superclass or class of the receiver.
	The current implemementation allows for a Trait to be used as argument"

	^ self class == aClass or: [ self class inheritsFrom: aClass ]
]

{ #category : #printing }
MpProxy >> longPrintOn: aStream limitedTo: sizeLimit indent: indent [
	| message |
	isDebugging ifTrue: [ ^'Proxy on Remote Object' ].
	message := Message selector: #longPrintOn:limitedTo:indent: arguments: {aStream. sizeLimit. indent}.
	^ self doesNotUnderstand: message		
]

{ #category : #marshalling }
MpProxy >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]

{ #category : #printing }
MpProxy >> printStringLimitedTo: limit [
	| message |
	isDebugging ifTrue: [^'Proxy on Remote Object']. "Make it possible to debug + avoid infinite debuggers"
	message := Message selector: #printStringLimitedTo: argument: limit.
	^ self doesNotUnderstand: message	
]

{ #category : #'class membership' }
MpProxy >> species [

	isDebugging ifTrue: [ ^ super class ]. "Make it possible to debug + avoid infinite debuggers"
	^ Smalltalk at: self speciesName ifAbsent: [ self basicSpecies ]
]

{ #category : #'class membership' }
MpProxy >> speciesName [

	| message species |
	message := Message selector: #species.
	species := self doesNotUnderstand: message.
	^species name asSymbol
]

{ #category : #printing }
MpProxy >> stDisplayString [
	| message |
	isDebugging ifTrue: [ ^ 'Proxy on Remote Object' ]. "Make it possible to debug + avoid infinite debuggers"
	message := Message selector: #stDisplayString.
	^ self doesNotUnderstand: message
	
]

{ #category : #'initialize-release' }
MpProxy >> transporter: aTransporter remoteReference: aRemoteReference [
	remoteReference := aRemoteReference. 
	transporter := aTransporter.
]

{ #category : #accessing }
MpProxy >> yourself [
	^self
]
