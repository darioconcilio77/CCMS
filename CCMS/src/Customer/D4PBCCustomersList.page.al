namespace D4P.CCMS.Customer;

using D4P.CCMS.Environment;
using D4P.CCMS.Tenant;
using Microsoft.Sales.Customer;

page 62000 "D4P BC Customers List"
{
    ApplicationArea = All;
    Caption = 'D365BC Customers - Environment Management';
    CardPageId = "D4P BC Customer Card";
    Editable = false;
    PageType = List;
    SourceTable = "D4P BC Customer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(City; Rec.City)
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Contact Person Name"; Rec."Contact Person Name")
                {
                }
                field("Contact Person Email"; Rec."Contact Person Email")
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(CustomerFactBox; "D4P BC Customer FactBox")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(BCTenants)
            {
                ApplicationArea = All;
                Caption = 'BC Tenants';
                Image = List;
                RunObject = page "D4P BC Tenant List";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'View Business Central tenants for this customer.';
            }
            action(BCEnvironments)
            {
                ApplicationArea = All;
                Caption = 'Environments';
                Image = ViewDetails;
                RunObject = page "D4P BC Environment List";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'View Business Central environments for this customer.';
            }
        }
        area(Creation)
        {
            action(NewCustomer)
            {
                ApplicationArea = All;
                Caption = 'New D4S Customer by My Customers';
                Image = New;
                ToolTip = 'Create a new D4S customer base on Standard Customer';
                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerList: Page "Customer List";
                    PersonNameTxt: Label '%1 %2', Locked = true, Comment = '%1 is first name, %2 is last name';
                begin
                    CustomerList.LookupMode(true);
                    CustomerList.SetTableView(Customer);
                    if CustomerList.RunModal() = Action::OK then begin

                        CustomerList.GetRecord(Customer);

                        Rec.Init();
                        Rec."No." := '';
                        Rec.Insert(true);

                        Rec.Name := Customer.Name;
                        Rec.City := Customer.City;
                        Rec."Country/Region Code" := Customer."Country/Region Code";
                        Rec."Contact Person Name" := StrSubstNo(PersonNameTxt, Customer."First Name", Customer."Last Name");
                        Rec."Contact Person Email" := Customer."E-Mail";
                        Rec.Modify(true);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(BCTenantsPromoted; BCTenants)
            {
            }
            actionref(BCEnvironmentsPromoted; BCEnvironments)
            {

            }
        }
    }
}