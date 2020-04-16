if Meteor.isClient
    Router.route '/application/:doc_id/view', (->
        @layout 'layout'
        @render 'application_view'
        ), name:'application_view'
    Router.route '/application/:doc_id/edit', (->
        @layout 'layout'
        @render 'application_edit'
        ), name:'application_edit'

    Template.application_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'business'
        @autorun => Meteor.subscribe 'model_docs', 'internship'
    Template.application_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id






    Template.application_edit.events
        'click .delete_app': ->
            if confirm 'delete application?'
                Docs.remove @_id
                Router.go "/internship/#{@internship_id}/view"
