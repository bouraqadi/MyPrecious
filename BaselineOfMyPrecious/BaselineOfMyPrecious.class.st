Class {
	#name : #BaselineOfMyPrecious,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyPrecious
}

{ #category : #baselines }
BaselineOfMyPrecious >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: 'Equals' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'Concurrency' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ].

		spec 
			repository: 'github://bouraqadi/MyPrecious';
			package: #MyPrecious with: [
				spec requires: #('Equals' 'Concurrency')]
	].

]
