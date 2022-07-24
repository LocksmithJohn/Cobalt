//
//  NoteDetailsVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

final class NoteDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case cancel
        case saveNote
        case deleteNote
        case showDeleteAlert
        case showTransform
        case toggleAreasVisibility
        case toggleArea(name: String)
        case addAreaToNote(name: String)
        case deleteAreaFromNote(name: String)
    }

    @Published var noteValue: String = ""
    @Published var isDeleteAlertVisible = false
    @Published var isAreasViewVisible = false
    @Published var focusAreas = FocusAreas() {
        didSet {
            print("filterr focusAreas -----------------------")
            allFocusAreas.areas.forEach { value in
                print("filterr focusAreas : \(value)")
            }
        }
    }
    @Published var allFocusAreas = FocusAreas() {
       didSet {
           print("filterr allFocusAreas -----------------------")
           allFocusAreas.areas.forEach { value in
               print("filterr allFocusAreas : \(value)")
           }
       }
   }
    @Published var focusAreasForDisplay = [(name: String, exists: Bool)]() {
        didSet {
            print("filterr focusAreasForDisplay -----------------------")
            focusAreasForDisplay.forEach { value in
                print("filterr focusAreasForDisplay : \(value.exists), \(value.name)")
            }
        }
    }

    var transformItemVM: TransformItemVM?
    let actionSubject = PassthroughSubject<Action, Never>()
    let id: UUID
    let isCreating: Bool

    private let appstate: NoteDetailsAppState
    private let interactor: NoteDetailsInteractor
    private var newNote = NoteDTO(newID: UUID())  {
        didSet {
            print("filter newNote -----------------------")
            newNote.areas?.areas.forEach { value in
                print("filter newNote : \(value)")
            }
        }
    }

    init(id: UUID?,
         interactor: NoteDetailsInteractor,
         appstate: NoteDetailsAppState) {
        self.isCreating = id == nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID()
        super.init(screenType: .noteDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.noteDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] note in
                print("filter areas 3 : \(note.areas)")
                self?.noteValue = note.name
                if let areas = note.areas {
                    self?.focusAreas = areas
                }
            }
            .store(in: &cancellableBag)

        appstate.areasSubjectSubject
            .sink { [weak self] allFocusAreas in
                print("filter allFocusAreas: \(allFocusAreas.areas)")
                self?.allFocusAreas = allFocusAreas
            }
            .store(in: &cancellableBag)
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear:
            onAppearAction()
        case .saveNote:
            saveNoteAction()
        case .back:
            interactor.route(from: screenType, to: .notes)
            interactor.fetchNotes()
        case .deleteNote:
            interactor.deleteNote(id: id)
            interactor.route(from: screenType, to: .tasks)
        case .showTransform:
            GlobalRouter.shared.popOverType.send(.itemTransform(id: id))
            Haptic.impact(.light)
        case .cancel:
            cancelAction()
        case .showDeleteAlert:
            isDeleteAlertVisible = true
        case .toggleAreasVisibility:
            isAreasViewVisible.toggle()
        case let .toggleArea(name):
            toggleAreaAction(name)
        case let .addAreaToNote(name):
            addAreaToNoteAction(name)
            interactor.fetchAreas()
        case let .deleteAreaFromNote(name):
            deleteAreaFromNoteAction(name)
            interactor.fetchAreas()
        }
    }

    private func onAppearAction() {
        interactor.fetchNote(id: id)
        interactor.fetchAreas()
        updateAreasToDisplay()
    }

    private func toggleAreaAction(_ name: String) {
        if focusAreas.areas.contains(name) == true {
            focusAreas.deleteArea(areaName: name)
        } else {
            focusAreas.addArea(area: name)
        }
        print("filter focusAreas 3 : \(focusAreas.areas)")

        saveNoteItem()
        interactor.fetchNote(id: id)
        updateAreasToDisplay()
    }

    private func addAreaToNoteAction(_ name: String) {
        allFocusAreas.addArea(area: name)
        interactor.editAreasInItem(id: id, focusAreas: allFocusAreas)
    }

    private func deleteAreaFromNoteAction(_ name: String) {
        allFocusAreas.deleteArea(areaName: name)
        interactor.editAreasInItem(id: id, focusAreas: allFocusAreas)
    }

    private func saveNoteAction() {
        saveNoteItem()
        actionSubject.send(.back)
    }

    private func saveNoteItem() {
        newNote.name = noteValue
        newNote.areas = focusAreas
        if isCreating {
            if !newNote.name.isEmpty {
                interactor.saveNote(newNote)
            }
        } else {
            interactor.editItem(id: id, item: Item(newNote))
        }
    }

    private func updateAreasToDisplay() {
        focusAreasForDisplay = allFocusAreas.areas
            .map { area -> (name: String, exists: Bool) in
                (area, focusAreas.areas.contains(area) == true)
            }
    }

    private func cancelAction() {
        interactor.deleteNote(id: id)
        interactor.route(from: screenType, to: .notes)
        interactor.fetchNotes()
    }

}
