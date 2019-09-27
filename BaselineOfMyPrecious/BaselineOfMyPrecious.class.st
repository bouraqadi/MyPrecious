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
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'NetworkExtras' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'TaskIt' with: [
				spec
					repository: 'github://sbragagnolo/taskit' ].

		spec 
			repository: 'github://bouraqadi/MyPrecious';
			package: #MyPrecious with: [
				spec requires: #('Equals' 'Concurrency' 'TaskIt')];
			package: #MyPreciousTcp with: [
				spec requires: #('MyPrecious' 'NetworkExtras')]
	].

]
