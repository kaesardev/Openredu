require 'spec_helper'
require 'authlogic/test_case'
include Authlogic::TestCase

describe EducationsController do
  before do
    @user = Factory(:user)
    activate_authlogic
    UserSession.create @user
  end

  describe "POST 'create'" do
    before do
      @post_params = {:locale => "pt-BR", :format => "js",
        :user_id => @user.id, :high_school =>
        { :institution => "Institution", "end_year(1i)" => "2010",
          "end_year(2i)" => "1", "end_year(3i)" => "1",
          :description => "Lorem ipsum dolor sit amet, consectetur magna aliqua." }}
    end

    context "when success" do
      it "should be successful" do
        post :create, @post_params
        response.should be_success
      end

      it "creates an education" do
        expect {
          post :create, @post_params
        }.should change(Education, :count).by(1)
        Education.last.user.should == @user
        Education.last.educationable.should == HighSchool.last
      end
    end

    context "when failing" do
      before do
        @post_params[:high_school][:institution] = ""
      end

      it "does NOT create an education" do
        expect {
          post :create, @post_params
        }.should_not change(Education, :count)
      end

      it "does NOT create an high_school" do
        expect {
          post :create, @post_params
        }.should_not change(HighSchool, :count)
      end
    end
  end

  describe "POST 'update'" do
    before do
      @education = Factory(:education, :user => @user)
      @post_params = { :locale => "pt-BR", :format => "js",
        :user_id => @user.id, :id => @education.id,
        :high_school => { :institution => "New Inst." }}
    end

    context "when successful" do
      before do
        post :update, @post_params
      end

      it "should be successful" do
        response.should be_success
      end

      it "updates the educationable" do
        HighSchool.last.institution.should ==
          @post_params[:high_school][:institution]
      end
    end

    context "when failing" do
      before do
        @post_params[:high_school][:institution] = ""
        @old_institution = @education.educationable.institution
        post :update, @post_params
      end

      it "does NOT update the educationable" do
        HighSchool.last.institution.should == @old_institution
        assigns[:education].should_not be_valid
        assigns[:education].errors[:educationable].should_not be_empty
      end
    end
  end

  describe "POST 'destroy'" do
    before do
      @education = Factory(:education, :user => @user)
      @params = {:locale => "pt-BR", :format => "js", :user_id => @user.id,
        :id => @education.id }
    end

    it "should be successful" do
      post :destroy, @params
      response.should be_success
    end

    it "destroys the education" do
      expect {
        post :destroy, @params
      }.should change(Education, :count).by(-1)
    end

    it "destroys the educationable" do
      expect {
        post :destroy, @params
      }.should change(HighSchool, :count).by(-1)
    end
  end

end
