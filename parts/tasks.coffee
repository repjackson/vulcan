if Meteor.isClient
    Router.route '/tasks/', (->
        @layout 'layout'
        @render 'tasks'
        ), name:'tasks'
    Router.route '/task/:doc_id/view', (->
        @layout 'layout'
        @render 'task_view'
        ), name:'task_view'
    Router.route '/task/:doc_id/edit', (->
        @layout 'layout'
        @render 'task_edit'
        ), name:'task_edit'


    Template.task_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.task_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.task_edit.events
        'click .delete_task_item': ->
            if confirm 'delete task?'
                Docs.remove @_id
                Router.go "/m/task"

    Template.task_view.events
        'click .add_to_cart': ->
            console.log @
            Docs.insert
                model:'cart_item'
