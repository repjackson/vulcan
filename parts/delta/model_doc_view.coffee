if Meteor.isClient
    Template.model_doc_view.onCreated ->
        @autorun -> Meteor.subscribe 'model_from_slug', Router.current().params.model_slug
        @autorun -> Meteor.subscribe 'model_fields_from_slug', Router.current().params.model_slug
        # console.log Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'upvoters', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'downvoters', Router.current().params.doc_id

    Template.model_doc_view.helpers
        # current_model: ->
            # Router.current().params.model_slug
        template_exists: ->
            # false
            # current_model = Docs.findOne(Router.current().params.doc_id).model
            current_model = Router.current().params.model_slug
            if Template["#{current_model}_view"]
                # console.log 'true'
                return true
            else
                # console.log 'false'
                return false


        model_template: ->
            "#{Router.current().params.model_slug}_view"


    Template.model_doc_view.events
        'click .back_to_model': (e,t)->
            Session.set 'loading', true
            current_model = Router.current().params.model_slug
            Meteor.call 'set_facets', current_model, ->
                Session.set 'loading', false
            $(e.currentTarget).closest('.grid').transition('fade left', 250)
            Meteor.setTimeout ->
                Router.go "/m/#{current_model}"
            , 250
