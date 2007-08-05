<?
	class HTMLTemplateController extends Controller
	{
		public function main()
		{
			$this->setArg('content');
		}
		
		public function header()
		{
			$this->setArg('title');
		}
		
		public function sidebar()
		{
			
		}
		
		public function footer()
		{
			
		}
	}
?>