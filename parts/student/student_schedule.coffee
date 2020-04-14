if Meteor.isClient
    Router.route '/student_schedule/', (->
        @layout 'layout'
        @render 'student_schedule'
        ), name:'student_schedule'
    Router.route '/event/:doc_id/view', (->
        @layout 'layout'
        @render 'event_view'
        ), name:'event_view'
    Router.route '/event/:doc_id/edit', (->
        @layout 'layout'
        @render 'event_edit'
        ), name:'event_edit'


    Template.event_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_edit.events
        'click .delete_event_item': ->
            if confirm 'delete event?'
                Docs.remove @_id
                Router.go "/m/event"

    Template.event_view.events
        'click .add_to_cart': ->
            console.log @
            Docs.insert
                model:'cart_item'
